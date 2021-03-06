require 'rubygems'
require 'active_record'
class AppConfig  
  cattr_accessor :filename

  @@all=Array.new
  @@k_v=Hash.new

  def self.load(config_file, section=nil)
    if (config_file.nil?)
      if (not defined?(RAILS_ROOT))
        raise "undefined config_file"
      end
      config_file = File.join(RAILS_ROOT, "config", "application.yml")
    end

    raise "#{config_file}: doesn't exist or is unreadable" unless File.exists? config_file
    yml_contents=YAML.load(File.read(config_file))
    section=RAILS_ENV if section.nil? and defined? RAIL_ENV
#    puts "section is #{section} (#{section.nil? ? 'nil':''})"

    if ((!section.nil?) and (not defined? yml_contents[section] or yml_contents[section].nil?))
      raise "no section '#{section}' in #{config_file}"
    end

    config = section.nil? ? yml_contents : yml_contents[section]

    config.keys.each do |key|
      cattr_accessor key
      send("#{key}=", config[key])
      @@all << key
      @@k_v[key.to_sym]=config[key.to_sym]
    end

    common=yml_contents['common']
    if common
      common.keys.each do |key|
        cattr_accessor key
        send("#{key}=",common[key])
        @@all << key
        @@k_v[key.to_sym]=config[key.to_sym]
      end
    end                       # if common

    msg=@@all.sort.join(' ')

    self.filename=config_file

  end

  def self.get_kv(key)
    @@k_v[key.to_sym]
  end

  def self.get(name)
    self[name]
  end

  def self.[] (name)
    key=name.to_sym
    a=nil
    begin
      a=send("#{key}")
    rescue Exception => e
    end
    a
  end

  def self.all
    @@all
  end

#  puts "#{__FILE__} checking in"
end
