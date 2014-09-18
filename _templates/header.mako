<h1 class="logo" onclick="javascript:window.location='http://threebean.org/blog'"><span class="highlight">[</span>three<span class="highlight">]</span>Bean</h1>
<a href="http://github.com/ralphbean"><img style="position: absolute; top: 0; right: 0; border: 0;"
src="https://a248.e.akamai.net/camo.github.com/7afbc8b248c68eb468279e8c17986ad46549fb71/687474703a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f6461726b626c75655f3132313632312e706e67"
alt="Fork me on GitHub"></a>

% if bf.config.blog.disqus.enabled:
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
% endif

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
