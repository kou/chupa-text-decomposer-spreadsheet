module Helper
  def fixture_path(*components)
    base_dir = File.expand_path(__dir__)
    File.join(base_dir, "fixture", *components)
  end
end
