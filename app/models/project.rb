class Project
  PROJECTS = YAML.load_file(File.join(Rails.root, 'config', 'projects.yml'))

  def self.by_pivotal_id(id)
    new(*PROJECTS.find { |name, attributes| attributes['pivotal_project_id'] == id })
  end

  def initialize(name, attributes)
    @name = name
    @attributes = attributes
  end

  def default_slimtimer_prefix
    @attributes['default_slimtimer_prefix']
  end

  def tagged_slimtimer_prefixes
    @attributes['tagged_slimtimer_prefixes']
  end

  def slimtimer_task_prefix(tags = [])
    if tags.size > 0
      tagged_slimtimer_prefixes.each do |tag, prefix|
        return prefix if tags.include? tag
      end
    end
    default_slimtimer_prefix
  end
end
