<h1 class="logo" onclick="javascript:window.location='http://threebean.org/blog'"><span class="highlight">[</span>three<span class="highlight">]</span>Bean</h1>

<script type="text/javascript">
//<![CDATA[
(function() {
		var links = document.getElementsByTagName('a');
		var query = '?';
		for(var i = 0; i < links.length; i++) {
			if(links[i].href.indexOf('#disqus_thread') >= 0) {
				query += 'url' + i + '=' + encodeURIComponent(links[i].href) + '&';
			}
		}
		document.write('<script charset="utf-8" type="text/javascript" src="http://disqus.com/forums/${bf.config.blog.disqus.name}/get_num_replies.js' + query + '"></' + 'script>');
	})();
//]]>
</script>

<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-1943020-2']);
  _gaq.push(['_setDomainName', 'threebean.org']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>

<script
 id="datagrepper-widget"
 src="https://apps.fedoraproject.org/datagrepper/widget.js?css=false"
 data-user="ralph"
 data-rows_per_page="30">
</script>
