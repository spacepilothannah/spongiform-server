Sequel.migration do
  change do
    alter_table :domains do
      drop_column :allowed
      add_column :created_at, Time, null: false, default: Time.now
      set_column_default :created_at, nil
    end

    alter_table :requests do
      add_column :created_at, Time, null: false, default: Time.now
      set_column_default :created_at, nil
    end

  end
end
