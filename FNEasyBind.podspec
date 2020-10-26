Pod::Spec.new do |s|
  s.name             = 'FNEasyBind'
  s.version          = '0.1.1'
  s.summary          = 'FNEasyBind is a very basic and simple implementation of observables you can subscribe on.'
  
  s.description      = <<-DESC
FNEasyBind is a very basic and simple implementation of observables you can subscribe on. This library is intended to be used instead of importing entire RxSwift library, but it doesn't replace it.
                       DESC

  s.homepage         = 'https://github.com/fabiosoft/FNEasyBind'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fabiosoft' => 'fabionisci@gmail.com' }
  s.source           = { :git => 'https://github.com/fabiosoft/FNEasyBind.git', :tag => s.version.to_s }

  s.swift_version         = '5.1'
  s.ios.deployment_target = '9.0'
  
  s.source_files = 'FNEasyBind/Classes/**/*'
end
