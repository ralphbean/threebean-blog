<%page args="post"/>
<div class="blog_post">
  <a name="${post.slug}"></a>
  <h2 class="blog_post_title"><a href="${post.permapath()}" rel="bookmark" title="Permanent Link to ${post.title}">${post.title}</a></h2>
  <small>${post.date.strftime("%b %d, %Y")} | categories: 
<% 
   category_links = []
   for category in post.categories:
       if post.draft:
           #For drafts, we don't write to the category dirs, so just write the categories as text
           category_links.append(category.name)
       else:
           category_links.append("<a href='%s'>%s</a>" % (category.path, category.name))
%>
${", ".join(category_links)}
<a href="${post.permalink}#disqus_thread">View Comments</a>
</small><p/>

  <div class="post_prose">
    ${self.post_prose(post)}
  </div>

<span>
  <small><a href="${post.permalink}#disqus_thread">View Comments</a></small><br/>
  <div class="g-plusone" data-size="medium" data-width="300" data-href="${post.permapath()}"></div>
  <script type="text/javascript">
    (function() {
      var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
      po.src = 'https://apis.google.com/js/plusone.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
    })();
  </script>

  <a href="https://twitter.com/share" class="twitter-share-button"
  data-url="${post.permapath()}" data-text="${post.title}"
  data-via="ralphbean">Tweet</a>
  <script>!function(d,s,id){var
  js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>

  <iframe style="border: 0; margin: 0; padding: 0;"
          src="https://www.gittip.com/ralphbean/widget.html"
          width="48pt" height="22pt"></iframe>
</span> <!-- float right -->
</div>

<%def name="post_prose(post)">
  ${post.content}
</%def>

