class Yaml_parser
  # To change this template use File | Settings | File Templates.
  attr_accessor :path, :cat_vagrant, :all_projects

  def initialize path
    #@all_settings=[]
    @all_projects=[]

    @cat_vagrant = To_check_category.new("Vagrant\'s application.yml file '")
    @cat_vagrant_directory =  To_check_category.new("Related projects exist?", @cat_vagrant)
    @cat_vagrant_passwords =  To_check_category.new("Passwords are consistent?", @cat_vagrant)
    @cat_vagrant_misc =  To_check_category.new("Misc. ", @cat_vagrant)
    @cat_vagrant.add_a_check @cat_vagrant_directory
    @cat_vagrant.add_a_check @cat_vagrant_passwords
    @cat_vagrant.add_a_check @cat_vagrant_misc

    yaml_file = File.expand_path(File.dirname(__FILE__) + '/../../config/application.yml', "vagrant")
    vagrant_test_yaml = Settingslogic.new(yaml_file)
    vagrant_test_yaml.vagrant.each{ |t|
        find_rules("vagrant_tests", t, yaml_file)
        #puts t.inspect
      }

    # we can guess the path to the other project
    # so we can found the yaml
    @all_projects.each{ |project|
      #adding the standard application.yml file (dealkeeper.yml for the dealkeeper project)
      yaml_file=nil
      if project[0] != "dealkeeper_path"
        yaml_file = File.expand_path(File.expand_path(File.dirname(__FILE__) +"/../../../.." +project[1])+ "/config/application.yml")
      else
        yaml_file = File.expand_path(File.expand_path(File.dirname(__FILE__) +"/../../../.." +project[1])+ "/config/dealkeeper.yml")
      end

      vagrant_test_yaml = Settingslogic.new(yaml_file)
      vagrant_test_yaml.vagrant.each{ |t|
        find_rules("vagrant_tests", t, yaml_file)
      }

      #adding the database.yml for the project that need it
      yaml_file=nil
      if project[0] != "management_path" || project[0] != "feedback_path"
        yaml_file = File.expand_path(File.expand_path(File.dirname(__FILE__) +"/../../../.." +project[1])+ "/config/database.yml")
      end

    }

  end

  def find_rules project, rules, yaml_path
    if project == "vagrant_tests"
      find_rules_vagrant_test_project rules, yaml_path
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

  def check
    @cat_vagrant.check

    puts ""
    puts "Settings that have not been Checked".red
    puts "==================================="
    @cat_vagrant.print_non_check
  end



end