Gem::Specification.new do |s|
  s.name = 'mymedia_frontend'
  s.version = '0.2.0'
  s.summary = 'An admin frontend for a MyMedia project (under development).'
  s.authors = ['James Robertson']
  s.files = Dir["lib/mymedia_frontend.rb, 'data/mymedia_frontend.txt','data/css.txt'"]
  s.add_runtime_dependency('weblet', '~> 0.4', '>=0.4.0')
  s.signing_key = '../privatekeys/mymedia_frontend.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/mymedia_frontend'
end
