depends_on
count
for_each to create multiple instance according to map 
provider for selecting non-default provider configuration
lifecycle for lifecycle customization
    create_before_destroy: (Type: Bool)
    prevent_destroy: (Type: Bool)
    ignore_changes: (Type: List(Attribute Names))
provisioner and connection for taking extra action after resource creation