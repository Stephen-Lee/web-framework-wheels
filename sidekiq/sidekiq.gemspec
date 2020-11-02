Gem::Specification.new do |s|
  s.name        = 'sidekiq'
  s.version     = '1.0.0'
  s.date        = '2020-01-14'
  s.summary     = "a simple sidekiq implementation"
  s.description = "a simple sidekiq implementation"
  s.authors     = ["Stephen Lee"]
  s.email       = '471235649@qq.com'
  s.files       = ["lib/sidekiq.rb"]
  s.add_dependency 'redis'
  s.add_dependency 'connection_pool'
  s.license       = 'MIT'
end
