<title>${bf.config.blog.name} ${post is not UNDEFINED and ("- " + post.title) or ''}</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="${bf.util.site_path_helper(bf.config.blog.path,'/feed')}" />
<link rel="alternate" type="application/atom+xml" title="Atom 1.0"
href="${bf.util.site_path_helper(bf.config.blog.path,'/feed/atom')}" />
<link rel='stylesheet' href='/blog/static/css/threebean.css' type='text/css' />
<link rel='stylesheet' href='/blog/static/css/pygments_murphy.css' type='text/css' />
<link rel='stylesheet' href='/blog/static/css/pygments_monokai.css' type='text/css' />
