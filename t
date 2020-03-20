
[1mFrom:[0m /home/delta/Work/testcode/app/controllers/fix_costs_controller.rb @ line 24 FixCostsController#index:

     [1;34m4[0m: [32mdef[0m [1;34mindex[0m
     [1;34m5[0m:   @fix_costs = [1;34;4mFixCost[0m.page param_page
     [1;34m6[0m: 
     [1;34m7[0m:   store = current_user.store
     [1;34m8[0m:   start_day = [1;34;4mDateTime[0m.now - [1;34m90[0m.days
     [1;34m9[0m:   end_day = [1;34;4mDateTime[0m.now + [1;34m1[0m.day
    [1;34m10[0m:   graphs = graph start_day, end_day, store
    [1;34m11[0m:   gon.label = graphs[[1;34m0[0m]
    [1;34m12[0m:   gon.data = graphs[[1;34m1[0m]
    [1;34m13[0m:   gon.graph_name = [31m[1;31m"[0m[31mBiaya Pasti[1;31m"[0m[31m[0m
    [1;34m14[0m: 
    [1;34m15[0m:   search = filter_search params
    [1;34m16[0m: 
    [1;34m17[0m:   @search = search[[1;34m0[0m]
    [1;34m18[0m:   @fix_costs = search[[1;34m1[0m]
    [1;34m19[0m: 
    [1;34m20[0m:   respond_to [32mdo[0m |format|
    [1;34m21[0m:     format.html [32mdo[0m
    [1;34m22[0m:       @fix_costs = search[[1;34m1[0m].page param_page
    [1;34m23[0m:     [32mend[0m
 => [1;34m24[0m:     binding.pry
    [1;34m25[0m:   [32mend[0m
    [1;34m26[0m: [32mend[0m

