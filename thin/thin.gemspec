Gem::Specification.new do |s|
  s.name        = 'thin'
  s.version     = '1.0.0'
  s.date        = '2020-01-14'
  s.summary     = "a simple thin server implementation"
  s.description = "a simple thin server implementation"
  s.authors     = ["Stephen Lee"]
  s.email       = '471235649@qq.com'
  s.files       = ["lib/thin.rb"]

  s.add_dependency 'rack'
  s.add_dependency 'eventmachine'
  s.require_path  = "lib"
end
