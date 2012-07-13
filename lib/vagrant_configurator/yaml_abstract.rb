# Represents a Yaml configuration file
# The class attributes represent an agregator for all yaml for all project
# For the cross-projects configuration, you also have the class method self.run
class Yaml_abstract

  attr_reader :cat_checkors, :settings, :management
  attr_accessor :rules_not_created

  #path to the files
  @@urls = []

  # Other projects
  @@management = nil
  @@targeting = nil
  @@dealkeeper = nil
  @@integration = nil
  @@bannerserver = nil
  @@imageserver = nil
  @@reporting = nil
  @@analytics= nil
  @@feedback = nil
  @@banner = nil
  @@frontend = nil

  @@projects = [@@management, @@targeting, @@dealkeeper, @@integration, @@bannerserver, @@imageserver, @@reporting, @@analytics, @@feedback, @@banner, @@frontend]


  def initialize name, url, category_father
    @name = name
    @url = url

    @@urls << url
    @category_father = category_father
    @cat_checkors = To_check_category.new("#{@name} URL", @category_father)
    @category_father.add_a_check @cat_checkors
    @rules_not_created = []

    case @name
      when "management_path"
        @@management = self
      when "targeting_path"
        @@targeting = self
      when "dealkeeper_path"
        @@dealkeeper = self
      when "integration_path"
        @@integration = self
      when "bannerserver_path"
        @@bannerserver = self
      when "imageserver_path"
        @@imageserver = self
      when "reporting_path"
        @@reporting = self
      when "analytics_path"
        @@analytics = self
      when "feedback_path"
        @@feedback = self
      when "banner_path"
        @@banner = self
      when "frontend_path"
        @@frontend = self
      else
        puts "error: VM name not detected:"+name # TODO raise error?
    end


  end

  ## Run the cross-project configuration checker
  ## assessment: all the project are already created (in order to be linked in the class attributes)
  def run
    @@settings = parse_settings
    find_rules_cross_projects_passwords
    create_rules_cross_project
  end

  ## From the rules we know, we will found the one which will have to be checked
  def create_rules_cross_project     #TODO RENAME
    @rules_not_created.each_index{ |i|

      rules_to_create = @rules_not_created[i]
      #puts "gefunden"+@rules_not_created.inspect
      if i < @rules_not_created.size-1
        checkor = Password_checkor.new(@rules_not_created[0][1], @rules_not_created[i+1][1])     #TODO rename
        check =  To_check.new(checkor, true, "beetween #{@rules_not_created[0]} and  #{@rules_not_created[i+1]}", "nil", @cat_checkors)
        @cat_checkors.add_a_check check
      end
    }
  end

  def find_rules_cross_projects_passwords #TODO RENAME
    @@settings.each{ |rules|
     # puts rules.inspect
      if @yaml_path =~ /database.yml$/
        if rules[0] == "username"
       #   @settings << [@name, rules[1]]
          #return
        elsif rules[0] == "password"
        #  @settings <<   [@name, rules[1]]
        #return
        end
      else # it's a application.yml document'
        if rules[0] == "mysql_username"
          #@settings << [@name, rules[1]]
          # return
        elsif rules[0] == "mysql_password"
         # @settings <<   [@name, rules[1]]
         #return
        elsif rules[0] == "management_base_url" ||  rules[0] == "rest_host" || rules[0] == "management_url" || rules[0] == "deal_management_host"  || rules[0] == "rtc.rest_host"
         @@management.rules_not_created << [rules[0], rules[1]]    unless @name != "management_path"
         #return
        elsif rules[0] == "targeting_host" || rules[0] == "api_url" ||  rules[0] == "targeting_base_url" ||  rules[0] == "targeting_url" ||  rules[0] == "targetingApi"
          @@targeting.rules_not_created << [rules[0], rules[1]]   unless @name != "targeting_path"
          #return
        else
          uncheck = Uncheck_checkor.new
          check =  To_check.new(uncheck, nil, @name+rules.to_s, "nil", @category_father)
          #@category_father.add_a_noncheck check
        end
      end
    }
    puts "\n"
  end



  # read the settings of each yaml file and add them to the class attribute @@settings
  def parse_settings
    complex_settings = []
    @@urls.each{ |url|
      yaml = Settingslogic.new(url)

      complex_settings_tmp = []
      yaml.vagrant.each{ |t|
        complex_settings_tmp = uncomplex_settings([t])
        complex_settings_tmp.each{|neo_settings|
          complex_settings <<  neo_settings
        }
      }
    }
    complex_settings
  end

  ## In a yaml file, the settings can be categorize and under categorized.
  ## This function read the settings return a table with all the settings like: [[cat_1.cat_2..cat_n.key, val ], ...]
  # Recursive function
  def uncomplex_settings settings
    res=nil
    neo_settings = settings

    # stop condition
    the_end = true
    settings.each{ |setting|
      if setting[1].class == Hash
        the_end=false
        break
      end
    }
    if the_end
      return settings
    end

    settings.each{ |setting|
      root_key=setting[0]

      if true==false
      elsif setting[1].class != Array &&  setting[1].class != Hash
        #return [setting] # should be a [[ ]]
        #res = [setting]
      elsif setting[1].class == Array
        #puts "error!"
        #current=setting
        #setting.each_index{ |i|
        #  if i == 0
        #    break
        #  else
        #    hash = setting[i]
        #  end
        #  hash[1]="PD" if hash[1]==nil
        #  new_obj=[root_key+"."+hash[0], hash[1]]
        #  current <<  new_obj
        #  current.delete_at(1)
        #}
        #current.delete_at(0)
        #puts "\t o1="+current.inspect
        #puts "\t o1="+neo_settings.inspect
        #uncomplex_settings current


      elsif setting[1].class == Hash
        current=setting
        setting[1].each{ |hash|
          hash[1]="PD" if hash[1]==nil
          new_obj=[root_key+"."+hash[0], hash[1]]
          settings <<  new_obj
        }
        setting.delete_at(1)
        settings.delete setting

        uncomplex_settings settings
      else
        puts "error" # TODO throw exception?
      end


    }
    settings
  end

end