class Refresh
	def self.asset_values
		Store.all.each do |store|
			items = Item.where("stock > 0").where(store: store)
			total = 0
			items.each do |item|
				total += item.buy
			end

			asset_value = AssetValue.find_by(store: store, date: Date.today)
			if asset_value.present?
				asset_value.nominal = total
				asset_value.save!
			else
				asset_value = AssetValue.create store: store, nominal: total, 
					invoice: "AVL-"+DateTime.now.to_i.to_s+"-"+store.id.to_s,
					date: Date.today
			end
		end
	end
end