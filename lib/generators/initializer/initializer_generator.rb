class InitializerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def copy_initializer_file
    copy_file "locale_diff.rb", "config/initializers/locale_diff.rb"
  end

end
