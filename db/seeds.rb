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

main_crew_project_role = ProjectRole.create :name =>  PROJECT_ROLE[:main_crew]
crew_project_role = ProjectRole.create :name => PROJECT_ROLE[:crew]
pm_project_role = ProjectRole.create :name => PROJECT_ROLE[:project_manager]
ae_project_role = ProjectRole.create :name => PROJECT_ROLE[:account_executive]
prod_project_role = ProjectRole.create :name => PROJECT_ROLE[:production]
post_prod_project_role = ProjectRole.create :name => PROJECT_ROLE[:post_production]
qc_project_role = ProjectRole.create :name => PROJECT_ROLE[:quality_control]
head_project_manager_project_role = ProjectRole.create :name => PROJECT_ROLE[:head_project_manager]

# Creating Package


beauty_shoot_package = Package.create_object( admin, {
  :title => "Beauty Shoot"
})

pre_wedding_package = Package.create_object( admin, {
  :title => "Pre Wedding"
})  

wedding_package = Package.create_object( admin, {
  :title => "Wedding Day Coverage"
})

maternity_package = Package.create_object( admin, {
  :title => "Maternity, before the baby is born"
})

package_array = [
    beauty_shoot_package, 
    pre_wedding_package,
    wedding_package,
    maternity_package 
  ]
 

canvas =  Deliverable.create_object( admin, {
  :name => "Canvas",
  :has_sub_item => false
})

photo_clip =  Deliverable.create_object( admin, {
  :name => "Photo Clip",
  :has_sub_item => false
})

album =  Deliverable.create_object( admin, {
  :name => "Album",
  :has_sub_item => true,
  :sub_item_name => "Edited Pics",
  :sub_item_quantity => 50
})


# Create Deliverable Component : CANVAS
DeliverableComponent.create_child_object( admin, canvas, {
  :name => "Frame"
}) 

DeliverableComponent.create_child_object( admin, canvas, {
  :name => "Image"
}) 

# Create Deliverable Component : ALBUM
DeliverableComponent.create_child_object( admin, album, {
  :name => "Cover"
}) 

DeliverableComponent.create_child_object( admin, album, {
  :name => "Album Content"
})

DeliverableComponent.create_child_object( admin, album, {
  :name => "Packaging"
})

# Create Deliverable Component : Photoclip
DeliverableComponent.create_child_object( admin, photo_clip, {
  :name => "CD Cover"
}) 

DeliverableComponent.create_child_object( admin, photo_clip, {
  :name => "Photoclip"
})
 
 
# CREATING THE DELIVERABLE SUBCRIPTION 

DeliverableSubcription.create_child_object( admin, pre_wedding_package, :deliverable_id => canvas.id  ) 
DeliverableSubcription.create_child_object( admin, pre_wedding_package, :deliverable_id => album.id  ) 


