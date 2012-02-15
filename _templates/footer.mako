<div class="push"></div>

<div class="footer">
<p><a href="http://threebean.org"><img style="vertical-align:middle;" src="https://secure.gravatar.com/avatar/ba940b433c2695635d32d2c4aec00540?s=32&d=mm"/> 
[three]Bean.org</a></p>
</div>

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
