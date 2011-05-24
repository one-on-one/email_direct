require 'rake'

spec = Gem::Specification.new do |s|

  s.name         = 'one-email_direct'
  s.version      = '0.6.6'

  s.authors      = ['Pedro Salgado']
  s.email        = ['pedro.salgado@1on1.com']

  s.platform     = Gem::Platform::RUBY

  s.homepage     = 'https://github.com/one-on-one/email_direct'

  s.summary      = 'One on One EmailDirect ruby gem.'
  s.description = <<EOF
One on One EmailDirect ruby gem.
EOF

  s.has_rdoc     = true
  s.extra_rdoc_files = ["README.md"]


  s.require_path = 'lib'
  s.files        = FileList["{lib}/**/*"].to_a + ['lib/emaildirect.wsdl', 'lib/emaildirect.secure.wsdl']
  s.test_files   = FileList["{test}/**/*test.rb"].to_a


  s.add_dependency 'savon', '0.9.2'
  s.add_dependency 'steenzout-cfg', '1.0.4'
  s.add_dependency 'tenjin', '0.6.1'

end
