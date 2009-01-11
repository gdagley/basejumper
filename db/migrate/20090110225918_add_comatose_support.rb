class ComatosePage < ActiveRecord::Base
  set_table_name 'comatose_pages'
  acts_as_versioned :table_name=>'comatose_page_versions', :if_changed => [:title, :slug, :keywords, :body]
end


class AddComatoseSupport < ActiveRecord::Migration

  # Schema for Comatose version 0.7+
  def self.up
    create_table :comatose_pages do |t|
      t.integer   "parent_id"
      t.text      "full_path",   :default => ''
      t.string    "title",       :limit => 255
      t.string    "slug",        :limit => 255
      t.string    "keywords",    :limit => 255
      t.text      "body"
      t.string    "filter_type", :limit => 25, :default => "Textile"
      t.string    "author",      :limit => 255
      t.integer   "position",    :default => 0
      t.integer   "version"
      t.datetime  "updated_on"
      t.datetime  "created_on"
    end
    
    ComatosePage.create_versioned_table
    
    puts "Creating the default 'Home Page'..."
    home = ComatosePage.create( :title=>'Home Page', :body=>"h1. Welcome\n\nYour content goes here... Log in and see Admin -> Content Management", :author=>'System' )
    puts "Creating the default '_shared'..."
    shared = ComatosePage.create( :parent_id => home.id, :full_path => '_shared', :title=>'_shared', :slug => '_shared', :body=>"Content beneath this page will be used as partials throughout the system and not full pages.", :author=>'System' )
    puts "Creating the default '_shared/sidebar-example'..."
    ComatosePage.create( :parent_id => shared.id, :full_path => '_shared/sidebar-example', :title=>'sidebar-example', :slug => 'sidebar-example', :body=>"h3. Sidebar Example\n\nThis is an example of some content that could go in the sidebar\n\nAnd another paragraph to go with it.", :author=>'System' )
    puts "Creating the default '404'..."
    ComatosePage.create( :parent_id => home.id, :full_path => '404', :title=>'Page Not Found', :slug => '404', :body=>"We could not find what you were looking for.", :author=>'System' )
    puts "Creating the default 'About'..."
    ComatosePage.create( :parent_id => home.id, :full_path => 'about', :title=>'About', :slug => 'about', :body=>"Your 'About' page goes here.", :author=>'System' )
    puts "Creating the default 'FAQ'..."
    ComatosePage.create( :parent_id => home.id, :full_path => 'faq', :title=>'Frequently Asked Questions', :slug => 'faq', :body=>"Your 'FAQ' page goes here.", :author=>'System' )
    puts "Creating the default 'Privacy'..."
    ComatosePage.create( :parent_id => home.id, :full_path => 'privacy', :title=>'Privacy Policy', :slug => 'privacy', :body=>"Your 'Privacy Policy' page goes here.", :author=>'System' )
  end

  def self.down
    ComatosePage.drop_versioned_table
    drop_table :comatose_pages
  end

end
