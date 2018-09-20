Sequel.migration do
  change do
    add_column :requests, :requested_at, Time, null: true
  end
end
