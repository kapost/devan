Devan
=====
Devan is an [Adobe CRX](http://wem.help.adobe.com/enterprise/en_US/10-0/core/getting_started/overview.html) 
*client*.

Getting Started
---------------
Initialize a remote repository instance:

```ruby
repo = Devan::Repository.new('http://localhost:4502')
repo.login('admin', 'admin')
```

Navigate/Find:

```ruby
puts repo.root.children
puts repo.root.find('content').children
puts repo.root.node('content/blog').find('01').children
```

Create:

```ruby
attrs = {:title => 'my awesome post', :text => '<b>awesome</b>'}
puts repo.root.node('content/blog/01').add('my_post', attrs)
```

Update:

```ruby
node = repo.root.node('content/blog/01/my_post')
node.update_attributes(:title => 'a new post title')
```

Delete:

```ruby
node = repo.root.node('content/blog/01/my_post')
node.delete
```

TODO
----
* Proper Test Suite
* Documentation via [TomDoc](http://tomdoc.org) 

Contribute
----------
* Fork the project.
* Make your feature addition or bug fix.
* Do **not** bump the version number.
* Send me a pull request. Bonus points for topic branches.

License
-------
Copyright (c) 2013, Mihail Szabolcs

Devan is provided **as-is** under the **MIT** license. For more information see
LICENSE.
