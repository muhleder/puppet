#This is a basic VCL configuration file for varnish.  See the vcl(7)
#man page for details on VCL syntax and semantics.
#
#Default backend definition.  Set this to point to your content
#server.
#
backend default {
.host = "127.0.0.1";
.port = "8080";
}

acl purge {
  "localhost";
}

sub vcl_recv {

  if (req.request == "PURGE") {
    if(!client.ip ~ purge) {
      error 405 "Not allowed.";
    }

    purge("req.url == " req.url);
    purge("req.url == /blog " );
  }

	/* If not Bedruthan send to apache */
	if (req.http.host !~ "^(www.)?(bedruthan)"   || req.url ~ "^/blog") {
	   return (pipe);
	}

	/* Wordpress Admin */
	if (req.url ~ "wp-(login|admin)") {
	  return (pass);
        }

	set req.http.Cookie = regsuball(req.http.Cookie, "(^|;\s*)(__[a-z]+|has_js)=[^;]*", "");

	/* Drupal and Bedruthan static folders */
	if (req.request == "GET" && req.url ~ "^/sites/|^/webcam/^/files/|^/misc/|^/themes/") {
	  /* we only ever want to deal with GET requests, we are working */
	  /* on the assumption that everything in sites is served the same */
	  /* to all users so we don't want the cookie */
	  unset req.http.cookie;
	  return (lookup);
	}
	if (req.request == "GET" && req.url ~ "^/user|^/logout|^/admin|^/monitor") {
	  /* we only ever want to deal with GET requests, we are working */
	  /* on the assumption that everything in sites is served the same */
	  /* to all users so we don't want the cookie */
	  return (pass);
	}
	if (req.url ~ "\.(png|gif|jpg|swf|css|js|ico)$") {
		unset req.http.Cookie;
		return (lookup);
	}
    if (req.request == "GET" && req.http.Cookie !~ "DRUPAL_VARNISH") {
      /* It was tempting to unset.http.cookie; here but it's needed to */
      /* stop users who log out getting the last page they saw logged in */
	  unset req.http.cookie;
      return (lookup);
    }

	return (pass);

}


// Strip any cookies before an image/js/css is inserted into cache.
// Also: future-support for ESI.
sub vcl_fetch {
  if (req.url ~ "\.(png|gif|jpg|swf|css|js)$") {
    unset beresp.http.set-cookie;
  }
  if (req.request == "GET" && req.url ~ "^/webcam/") {
    // Cache Bedruthan webcam images for 1 hour
    unset beresp.http.Set-Cookie;
    set beresp.cacheable = true;
    // we can set how long Varnish will keep the object here, or later
    set beresp.ttl = 15m;
    // debug add this and you'll see it in the headers if we came here
    set beresp.http.X-Drupal-Varnish-Debug = "webcam image";
  }
  if (beresp.cacheable) {
    /* Remove Expires from backend, it's not long enough */
    unset beresp.http.expires;
	/* Set the clients TTL on this object */
    set beresp.http.cache-control = "max-age = 3600";
	/* Set how long Varnish will keep it */
	set beresp.ttl = 1w;
	/* marker for vcl_deliver to reset Age: */
    set beresp.http.magicmarker = "1";
    return(deliver);
  }
  if (req.request == "GET" && req.http.cookie !~ "DRUPAL_VARNISH") {
    if (req.url !~ "(/[a-zA-Z]{2})?/user" && req.url !~ "(/[a-zA-Z]{2})?/admin") {
      /* We don't want the ttl so long on these pages, so we must set */
      /* it in the different if blocks rather than cacheable here */
      set beresp.ttl = 30m;
      unset beresp.http.Set-Cookie;
      if (req.url !~ "^[a-zA-Z]{2}/") {
        /* make sure that language is taken into account on caching pages */
        /* without a langage code in the url, and make sure that caches */
        /* know if there is a cookie with the page it's not to use the */
        /* cached one */
        set beresp.http.Vary = "Accept-Language, Cookie";
      }
      else {
        set beresp.http.Vary = "Cookie";
      }
    }
  }

}


sub vcl_deliver {
	if (resp.http.magicmarker) {
        /* Remove the magic marker */
        unset resp.http.magicmarker;
        /* By definition we have a fresh object */
        set resp.http.age = "0";
	}
}



sub vcl_hash {
  if (req.http.Cookie) {
    set req.hash += req.http.Cookie;
  }
}

sub vcl_error {
  // Let's deliver a slightly more friedly error page.
  // You can customize this as you wish.
  set obj.http.Content-Type = "text/html; charset=utf-8";
  synthetic {"
  <?xml version="1.0" encoding="utf-8"?>
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  <html>
    <head>
      <title>"} obj.status " " obj.response {"</title>
      <style type="text/css">
      #page {width: 400px; padding: 10px; margin: 20px auto; border: 1px solid black; background-color: #FFF;}
      p {margin-left:20px;}
      body {background-color: #DDD; margin: auto;}
      </style>
    </head>
    <body>
    <div id="page">
    <h1>Page Could Not Be Loaded</h1>
    <p>We're very sorry, but the page could not be loaded properly. This should be fixed very soon, and we apologize for any inconvenience.</p>
    <hr />
    <h4>Debug Info:</h4>
    <pre>
Status: "} obj.status {"
Response: "} obj.response {"
XID: "} req.xid {"
</pre>
      <address><a href="http://www.varnish-cache.org/">Varnish</a></address>
      </div>
    </body>
   </html>
   "};
   return(deliver);
}














#
#Below is a commented-out copy of the default VCL logic.  If you
#redefine any of these subroutines, the built-in logic will be
#appended to your code.
#
#sub vcl_recv {
#    if (req.request != "GET" &&
#      req.request != "HEAD" &&
#      req.request != "PUT" &&
#      req.request != "POST" &&
#      req.request != "TRACE" &&
#      req.request != "OPTIONS" &&
#      req.request != "DELETE") {
#        /* Non-RFC2616 or CONNECT which is weird. */
#        return (pipe);
#    }
#    if (req.request != "GET" && req.request != "HEAD") {
#        /* We only deal with GET and HEAD by default */
#        return (pass);
#    }
#    if (req.http.Authorization || req.http.Cookie) {
#        /* Not cacheable by default */
#        return (pass);
#    }
#    return (lookup);
#}
#
#sub vcl_pipe {
#    return (pipe);
#}
#
#sub vcl_pass {
#    return (pass);
#}
#
#sub vcl_hash {
#    set req.hash += req.url;
#    if (req.http.host) {
#        set req.hash += req.http.host;
#    } else {
#        set req.hash += server.ip;
#    }
#    return (hash);
#}
#
#sub vcl_hit {
#    if (!obj.cacheable) {
#        return (pass);
#    }
#    return (deliver);
#}
#
#sub vcl_miss {
#    return (fetch);
#}
#
#sub vcl_fetch {
#    if (!obj.cacheable) {
#        return (pass);
#    }
#    if (obj.http.Set-Cookie) {
#        return (pass);
#    }
#    set obj.prefetch =  -30s;
#    return (deliver);
#}
#
#sub vcl_deliver {
#    return (deliver);
#}
#
#sub vcl_discard {
#    /* XXX: Do not redefine vcl_discard{}, it is not yet supported */
#    return (discard);
#}
#
#sub vcl_prefetch {
#    /* XXX: Do not redefine vcl_prefetch{}, it is not yet supported */
#    return (fetch);
#}
#
#sub vcl_timeout {
#    /* XXX: Do not redefine vcl_timeout{}, it is not yet supported */
#    return (discard);
#}
#

