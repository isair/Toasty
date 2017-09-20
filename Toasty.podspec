Pod::Spec.new do |s|
  s.name = 'Toasty'
  s.version = '0.2.0'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.summary = 'App extension compatible Toast library for iOS, tvOS, and OS X.'

  s.homepage = 'https://github.com/isair/Toasty'
  s.author = { 'Baris Sencan' => 'baris.sncn@gmail.com' }
  s.social_media_url = 'https://twitter.com/IsairAndMorty'

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.source       = { :git => 'https://github.com/isair/Toasty.git', :tag => s.version }
  s.source_files = 'Toasty'
end
