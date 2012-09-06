# USER_ROLE = { 
#   :admin => "Admin", #  add supplier 
#   :crew => "Crew",
#   :head_project_manager => "HeadProjectManager", # create projects, add client  , edit project membership
#   :project_manager => "ProjectManager",
#   :account_executive => "AccountExecutive" , 
#   # Back office roles .. there can be designer editor 
#   :production => "Production",
#   :post_production => "PostProduction"  
# }


admin_role = Role.create :name => USER_ROLE[:admin]
employee_role = Role.create :name => USER_ROLE[:employee]
head_pm_role = Role.create :name => USER_ROLE[:head_project_manager] 

admin = User.create_main_user( :name => "Admin", :password => "willy1234", :password_confirmation => "willy1234", :email => "admin@gmail.com" ) 
admin.add_role_if_not_exists( head_pm_role ) 
admin.reload
if admin.has_role?(:admin)
  puts "THe admin has role ADMIN! \n"*10
else
  puts "THe admin DOESN't have role ADMIN! \n"*10
end
head_pm = User.create_user_with_role( admin, [head_pm_role], :name => "Head PM", 
                      :password => "willy1234", 
                      :password_confirmation => "willy1234", 
                      :email => "head_pm@gmail.com" )
                      
if head_pm.nil?
  puts "THe HEAD PM IS NIL! \n"*10
  
else
  puts "THe HEAD PM IS NOT  NIL! \n"*10
end
pm = User.create_basic_user(admin, :name => "PM", :password => "willy1234", :password_confirmation => "willy1234", :email => "pm@gmail.com" )
ae = User.create_basic_user(admin, :name => "AE", :password => "willy1234", :password_confirmation => "willy1234", :email => "ae@gmail.com" )
prod = User.create_basic_user( admin,:name => "PROD1", :password => "willy1234", :password_confirmation => "willy1234", :email => "prod1@gmail.com" )
postprod = User.create_basic_user(admin, :name => "postProd", :password => "willy1234", :password_confirmation => "willy1234", :email => "post_prod@gmail.com" )
prod2  = User.create_basic_user(admin, :name => "Prod 2", :password => "willy1234", :password_confirmation => "willy1234", :email => "prod2@gmail.com" )



   