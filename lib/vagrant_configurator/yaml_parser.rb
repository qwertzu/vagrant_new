require File.expand_path(File.dirname(__FILE__) + '/vagrant_configurator_helper')
class Yaml_parser
  attr_accessor :path, :cat_vagrant, :all_projects

  def initialize path
    @all_projects=[]
    @mysql_username=[]
    @mysql_passwords=[]
    @all_yaml=[]

    # Creating the categories and subcategories that will be displayed
    @cat_vagrant = ValidatorCatagory.new("Vagrant\'s application.yml file ")
    @cat_vagrant_directory =  ValidatorCatagory.new("Related projects exist?", @cat_vagrant)
    @cat_vagrant_misc =  ValidatorCatagory.new("Misc. ", @cat_vagrant)
    @cat_vagrant.add_a_check @cat_vagrant_directory
    @cat_vagrant.add_a_check @cat_vagrant_misc

    @cat_consistency = ValidatorCatagory.new("Cross project consitency")
    @cat_consistency_mysql = ValidatorCatagory.new("Mysql identification", @cat_consistency)
    @cat_consistency_url = ValidatorCatagory.new("Project URL Consitency", @cat_consistency)

    @cat_vagrant_mysql_username = ValidatorCatagory.new("Username", @cat_consistency_mysql)
    @cat_vagrant_mysql_passwords = ValidatorCatagory.new("Passwords", @cat_consistency_mysql)

    @cat_consistency.add_a_check @cat_consistency_mysql
    @cat_consistency.add_a_check @cat_consistency_url

    @cat_consistency_mysql.add_a_check @cat_vagrant_mysql_username
    @cat_consistency_mysql.add_a_check @cat_vagrant_mysql_passwords

    #Parsing all the Yaml file for the vagrant project - TODO make it more OO
    yaml_file = File.expand_path(File.dirname(__FILE__) + '/../../config/application.yml', "vagrant")
    vagrant_test_yaml = Settingslogic.new(yaml_file)
    vagrant_test_yaml.vagrant.each{ |t|
        find_rules("vagrant_tests", t, yaml_file)
      }


   ## Creating each project and creating the cross project rules
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
   # TODO move it for OO
  def find_rules project, rules, yaml_path
    if project == "vagrant_tests"
      find_rules_vagrant_test_project rules, yaml_path
    else # yaml_path =~ /database.yml$/
      add_supported_settings rules, yaml_path
    end
  end

  # TODO move it for OO
  def find_rules_vagrant_test_project rules, yaml_path
    if rules[0] == "targeting_path" || rules[0] == "management_path" || rules[0] == "dealkeeper_path" ||
            rules[0] == "integration_path" || rules[0] == "bannerserver_path" || rules[0] == "imageserver_path" ||
            rules[0] == "reporting_path" || rules[0] == "analytics_path" || rules[0] == "feedback_path" ||
            rules[0] == "banner_path" || rules[0] == "frontend_path"
      dirCheck = Directory_checkor.new(File.expand_path(File.dirname(__FILE__) +"/../../../.." +rules[1]))
      check =  Validator.new(dirCheck, true, dirCheck.directory.to_s+" exists?", "nil", @cat_vagrant_directory)
      @cat_vagrant_directory.add_a_check check
      @all_projects << rules

    elsif rules[0] == "base_box"
      boxCheck = Box_checkor.new(rules[1])
      check =  Validator.new(boxCheck, true, "basebox #{rules[1]} exists?", "nil", @cat_vagrant_misc)
      @cat_vagrant_misc.add_a_check check

    elsif rules[0] == "vagrant_file"
      filecheckor = File_checkor.new(rules[1])
      check =  Validator.new(filecheckor, true, "file #{rules[1]} exists?", "nil", @cat_vagrant_misc)
      @cat_vagrant_misc.add_a_check check

    elsif true == false
      #TODO if we know that we wont test those stuff

    else
      uncheck = UnsupportedSettingCheckor.new
      check =  Validator.new(uncheck, nil, yaml_path+rules.to_s, "nil", @cat_vagrant_unchecked)
      @cat_vagrant.add_a_noncheck check
    end

  end

  def check
    #@cat_vagrant.check
    #@cat_consistency.check
    #
    #puts ""
    #puts "Settings that have not been Checked".red
    #puts "==================================="
    #@cat_vagrant.print_non_check
    #@cat_consistency.print_non_check
    ValidatorCatagory.check_all
  end



end