class InitializerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def copy_initializer_file
    copy_file "missing_text.rb", "config/initializers/missing_text.rb"
  end

end
