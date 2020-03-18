
[1mFrom:[0m /home/delta/Work/testcode/app/controllers/taxs_controller.rb @ line 24 TaxsController#create:

    [1;34m19[0m: [32mdef[0m [1;34mcreate[0m
    [1;34m20[0m:   tax = [1;34;4mTax[0m.new tax_params
    [1;34m21[0m:   tax.store = current_user.store
    [1;34m22[0m:   tax.user = current_user
    [1;34m23[0m:   tax.invoice = [31m[1;31m"[0m[31mTAX-[1;31m"[0m[31m[0m + [1;34;4mDateTime[0m.now.to_i.to_s + current_user.store.id.to_s
 => [1;34m24[0m:   binding.pry
    [1;34m25[0m:   [32mreturn[0m redirect_back_data_error new_tax_path, [31m[1;31m"[0m[31mData error[1;31m"[0m[31m[0m [32mif[0m tax.invalid?  
    [1;34m26[0m: 	tax.save!
    [1;34m27[0m: 	tax.create_activity [33m:create[0m, [35mowner[0m: current_user
    [1;34m28[0m: 	[32mreturn[0m redirect_success tax_path([35mid[0m: tax.id), [31m[1;31m"[0m[31mData disimpan[1;31m"[0m[31m[0m
    [1;34m29[0m: [32mend[0m

