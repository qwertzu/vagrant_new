class Yaml_parser
  # To change this template use File | Settings | File Templates.
  attr_accessor :path, :cat_vagrant, :all_projects

  def initialize path
    #@all_settings=[]
    @all_projects=[]
    @mysql_username=[]
    @mysql_passwords=[]
    #@management_url=[]
    #@targeting_url=[]
    @all_yaml=[]


    @cat_vagrant = To_check_category.new("Vagrant\'s application.yml file ")
    @cat_vagrant_directory =  To_check_category.new("Related projects exist?", @cat_vagrant)
    @cat_vagrant_misc =  To_check_category.new("Misc. ", @cat_vagrant)
    @cat_vagrant.add_a_check @cat_vagrant_directory
    @cat_vagrant.add_a_check @cat_vagrant_misc

    @cat_consistency = To_check_category.new("Cross project consitency")
    @cat_consistency_mysql = To_check_category.new("Mysql identification", @cat_consistency)
    @cat_consistency_url = To_check_category.new("Project URL Consitency", @cat_consistency)

    @cat_vagrant_mysql_username = To_check_category.new("Username", @cat_consistency_mysql)
    @cat_vagrant_mysql_passwords = To_check_category.new("Passwords", @cat_consistency_mysql)

    #@cat_consistency_url_management = To_check_category.new("Management URL", @cat_consistency_url)
    #@cat_consistency_url_targeting = To_check_category.new("Targeting URL", @cat_consistency_url)
    #@cat_consistency_url_dealkeeper = To_check_category.new("Dealkeeper URL", @cat_consistency_url)
    #@cat_consistency_url_integratio = To_check_category.new("Integration URL", @cat_consistency_url)
    #@cat_consistency_url_bannerserv = To_check_category.new("Bannerserver URL", @cat_consistency_url)
    #@cat_consistency_url_imageserv = To_check_category.new("Imageserver URL", @cat_consistency_url)
    #@cat_consistency_url_reporting = To_check_category.new("Reporting URL", @cat_consistency_url)
    #@cat_consistency_url_analytics = To_check_category.new("Analytics URL", @cat_consistency_url)
    #@cat_consistency_url_feedback = To_check_category.new("Feedback URL", @cat_consistency_url)
    #@cat_consistency_url_banner = To_check_category.new("Banner URL", @cat_consistency_url)
    #@cat_consistency_url_frontend = To_check_category.new("Frontend URL", @cat_consistency_url)

    @cat_consistency.add_a_check @cat_consistency_mysql
    @cat_consistency.add_a_check @cat_consistency_url

    @cat_consistency_mysql.add_a_check @cat_vagrant_mysql_username
    @cat_consistency_mysql.add_a_check @cat_vagrant_mysql_passwords

    #@cat_consistency_url.add_a_check @cat_consistency_url_management
    #@cat_consistency_url.add_a_check @cat_consistency_url_targeting
    #@cat_consistency_url.add_a_check @cat_consistency_url_dealkeeper
    #@cat_consistency_url.add_a_check @cat_consistency_url_integratio
    #@cat_consistency_url.add_a_check @cat_consistency_url_bannerserv
    #@cat_consistency_url.add_a_check @cat_consistency_url_imageserv
    #@cat_consistency_url.add_a_check @cat_consistency_url_reporting
    #@cat_consistency_url.add_a_check @cat_consistency_url_analytics
    #@cat_consistency_url.add_a_check @cat_consistency_url_feedback
    #@cat_consistency_url.add_a_check @cat_consistency_url_banner
    #@cat_consistency_url.add_a_check @cat_consistency_url_frontend



    yaml_file = File.expand_path(File.dirname(__FILE__) + '/../../config/application.yml', "vagrant")
    vagrant_test_yaml = Settingslogic.new(yaml_file)
    vagrant_test_yaml.vagrant.each{ |t|
        find_rules("vagrant_tests", t, yaml_file)
      }

    # we can guess the path to the other project
    # so we can found the yaml
    #@all_projects.each{ |project|
    #  #adding the standard application.yml file (dealkeeper.yml for the dealkeeper project)
    #  yaml_file=nil
    #  if project[0] != "dealkeeper_path"
    #    yaml_file = File.expand_path(File.expand_path(File.dirname(__FILE__) +"/../../../.." +project[1])+ "/config/application.yml")
    #  else
    #    yaml_file = File.expand_path(File.expand_path(File.dirname(__FILE__) +"/../../../.." +project[1])+ "/config/dealkeeper.yml")
    #  end
    #
    #  project_yaml = Settingslogic.new(yaml_file)
    #
    #
    #  complex_settings = []
    #  complex_settings_tmp = []
    #  project_yaml.vagrant.each{ |t|
    #  #  puts "GOT="+ uncomplex_settings([t]).inspect
    #      complex_settings_tmp = uncomplex_settings([t])
    #    #  puts "GOT="+ complex_settings_tmp.inspect
    #    complex_settings_tmp.each{|neo_settings|
    #      complex_settings <<  neo_settings
    #    }
    #  }
    #
    #  complex_settings.each{ |t|
    #    find_rules(project[0], t, yaml_file)
    #  }
    #
    #  #adding the database.yml for the project that need it
    #  yaml_file=nil
    #  if project[0] == "management_path" || project[0] == "feedback_path"
    #    yaml_file = File.expand_path(File.expand_path(File.dirname(__FILE__) +"/../../../.." +project[1])+ "/config/database.yml")
    #  end
    #
    #  if yaml_file != nil
    #    project_yaml = Settingslogic.new(yaml_file)
    #    project_yaml.vagrant.each{ |t|
    #      find_rules(project[0], t, yaml_file)
    #    }
    #  end
    #}
    #create_rules_cross_project



    #  if project[0] != "dealkeeper_path"
    #    yaml_file = File.expand_path(File.expand_path(File.dirname(__FILE__) +"/../../../.." +project[1])+ "/config/application.yml")
    #  else
    #    yaml_file = File.expand_path(File.expand_path(File.dirname(__FILE__) +"/../../../.." +project[1])+ "/config/dealkeeper.yml")
    #  end

    @all_projects.each{ |project|
      name = project[0]

        if project[0] != "dealkeeper_path"
          url = File.expand_path(File.expand_path(File.dirname(__FILE__) +"/../../../.." +project[1])+ "/config/application.yml")
        else
          url = File.expand_path(File.expand_path(File.dirname(__FILE__) +"/../../../.." +project[1])+ "/config/dealkeeper.yml")
        end

       #puts @cat_consistency_url.inspect
      yaml = Yaml_abstract.new name, url, @cat_consistency_url
      #yaml.update_self
      @all_yaml << yaml
      }

    @all_yaml.each{ |project|
      project.run
      }

  end

  def find_rules project, rules, yaml_path
    if project == "vagrant_tests"
      find_rules_vagrant_test_project rules, yaml_path
    else # yaml_path =~ /database.yml$/
      find_rules_cross_projects_passwords rules, yaml_path
    end
  end

  def find_rules_vagrant_test_project rules, yaml_path
    if rules[0] == "targeting_path" || rules[0] == "management_path" || rules[0] == "dealkeeper_path" ||
            rules[0] == "integration_path" || rules[0] == "bannerserver_path" || rules[0] == "imageserver_path" ||
            rules[0] == "reporting_path" || rules[0] == "analytics_path" || rules[0] == "feedback_path" ||
            rules[0] == "banner_path" || rules[0] == "frontend_path"
      dirCheck = Directory_checkor.new(File.expand_path(File.dirname(__FILE__) +"/../../../.." +rules[1]))
      check =  To_check.new(dirCheck, true, dirCheck.directory.to_s+" exists?", "nil", @cat_vagrant_directory)
      @cat_vagrant_directory.add_a_check check
      @all_projects << rules

    elsif rules[0] == "base_box"
      boxCheck = Box_checkor.new(rules[1])
      check =  To_check.new(boxCheck, true, "basebox #{rules[1]} exists?", "nil", @cat_vagrant_misc)
      @cat_vagrant_misc.add_a_check check

    elsif rules[0] == "vagrant_file"
      filecheckor = File_checkor.new(rules[1])
      check =  To_check.new(filecheckor, true, "file #{rules[1]} exists?", "nil", @cat_vagrant_misc)
      @cat_vagrant_misc.add_a_check check

    elsif true == false
      #TODO if we know that we wont test those stuff

    else
      uncheck = Uncheck_checkor.new
      check =  To_check.new(uncheck, nil, yaml_path+rules.to_s, "nil", @cat_vagrant_unchecked)
      @cat_vagrant.add_a_noncheck check
    end

      #case rules[0]
      #  when "management_path"
      #    Directory_checkor.new(File.expand_path(File.dirname(__FILE__) + rules[1]))
      #    puts "detected"
      #  when "targeting_path"
      #    puts "detected"
      #  when "dealkeeper_path"
      #    puts "detected"
      #  when "integration_path"
      #    puts "detected"
      #  when "bannerserver_path"
      #    puts "detected"
      #  when "imageserver_path"
      #    puts "detected"
      #  when "reporting_path"
      #    puts "detected"
      #  when "analytics_path"
      #    puts "detected"
      #  when "feedback_path"
      #    puts "detected"
      #  when "banner_path"
      #    puts "detected"
      #  when "frontend_path"
      #    puts "detected"
      #  else
      #    puts "undetected"
      #end
  end

  # TODO REMOVE
  def find_rules_cross_projects_passwords rules, yaml_path
    if yaml_path =~ /database.yml$/
      if rules[0] == "username"
        @mysql_username << [yaml_path, rules[1]]
        return
      elsif rules[0] == "password"
        @mysql_passwords <<   [yaml_path, rules[1]]
        return
      end
    else # it's a application.yml document'
      if rules[0] == "mysql_username"
        @mysql_username << [yaml_path, rules[1]]
        return
      elsif rules[0] == "mysql_password"
        @mysql_passwords <<   [yaml_path, rules[1]]
        return
      elsif rules[0] == "management_base_url" ||  rules[0] == "rest_host" || rules[0] == "management_url" || rules[0] == "deal_management_host"  || rules[0] == "rtc.rest_host"
        @management_url <<  [yaml_path, rules[1]]
        return
      elsif rules[0] == "targeting_host" || rules[0] == "api_url" ||  rules[0] == "targeting_base_url" ||  rules[0] == "targeting_url" ||  rules[0] == "targetingApi"
        @targeting_url <<  [yaml_path, rules[1]]
      end
    end

    uncheck = Uncheck_checkor.new
    check =  To_check.new(uncheck, nil, yaml_path+rules.to_s, "nil", @cat_consistency)
    @cat_consistency.add_a_noncheck check

  end

  # TODO REMOVE
  def create_rules_cross_project
    @mysql_username.each_index{ |i|
      if i < @mysql_username.size-1
        username_checkor = Password_checkor.new(@mysql_username[0][1], @mysql_username[i+1][1])
        check =  To_check.new(username_checkor, true, "beetween #{@mysql_username[0][0]} and  #{@mysql_username[i+1][0]}", "nil", @cat_vagrant_mysql_username)
        @cat_vagrant_mysql_username.add_a_check check
      end
    }

    @mysql_passwords.each_index{ |i|
      if i < @mysql_passwords.size-1
        password_checkor = Password_checkor.new(@mysql_passwords[0][1], @mysql_passwords[i+1][1])
        check =  To_check.new(password_checkor, true, "beetween #{@mysql_passwords[0][0]} and  #{@mysql_passwords[i+1][0]}", "nil", @cat_vagrant_mysql_passwords)
        @cat_vagrant_mysql_passwords.add_a_check check
      end
    }

    @management_url.each_index{ |i|
      if i < @management_url.size-1
        url_checkor = Password_checkor.new(@management_url[0][1], @management_url[i+1][1])
        check =  To_check.new(url_checkor, true, "beetween #{@management_url[0][0]} and  #{@management_url[i+1][0]}", "nil", @cat_consistency_url_management)
        @cat_consistency_url_management.add_a_check check
      end
    }

    @targeting_url.each_index{ |i|
      if i < @targeting_url.size-1
        url_checkor = Password_checkor.new(@targeting_url[0][1], @targeting_url[i+1][1])
        check =  To_check.new(url_checkor, true, "beetween #{@targeting_url[0][0]} and  #{@targeting_url[i+1][0]}", "nil", @cat_consistency_url_targeting)
        @cat_consistency_url_targeting.add_a_check check
      end
    }
  end

  def check
    @cat_vagrant.check
    @cat_consistency.check

    puts ""
    puts "Settings that have not been Checked".red
    puts "==================================="
    @cat_vagrant.print_non_check
    @cat_consistency.print_non_check
  end

  #TODO remove me
  def uncomplex_settings settings
    res=nil
    neo_settings = settings

     # check the ending condition
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
        puts "error"
      end


    }
      settings
  end

end