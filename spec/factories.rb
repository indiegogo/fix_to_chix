Factory.define :hello_world, :class => Post do |p|
  p.description 'this is the description of my first post'
  p.title 'my first post'
  p. ''
end

Factory.define :bye_earth, :class => Post do |p|
  p.description 'this is the description of my second post'
  p.title 'my second post'
  p. ''
end

Factory.define :bla, :class => LineItem do |l|
  l.description 'this is the description of my first post'
  l.title 'my first post'
  l. ''
end

Factory.define :anakin, :class => Author do |a|
  a.age 17
  a.blog 'I write a blog'
  a.name 'why the lucky stiff'
  a. ''
end

Factory.define :yoda, :class => Author do |a|
  a.age 900
  a.blog 'within you the force is'
  a.name 'the master'
  a. ''
end

