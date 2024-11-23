echo "☁️  Linting And Formatting Script Generation Running..."

cd ..

# Create The Hooks Directory Or Replace If Needed
SWIFT_LINT_CONFIG=".swiftlint.yml"
SWIFT_FORMAT_CONFIG=".swiftformat"

if [ -f ".swiftlint.yml" ]; then
    rm ".swiftlint.yml"
    echo "🗑️  Removing Existing SwiftLint Configuration"
fi

if [ -f ".swiftformat" ]; then
    rm ".swiftformat"
    echo "🗑️  Removing Existing SwiftFormat Configuration"
fi

# Create The Swift Lint Configuration
cat > "$SWIFT_LINT_CONFIG" << 'EOF'
# Excluded Paths
excluded:
  - Carthage
  - Pods
  - DerivedData
  - ../3rdParty
  - 3rdParty
  - ${PWD}/Carthage
  - ${PWD}/Pods
  - ${PWD}/DerivedData
  - ${PWD}/3rdParty

# Disabled Rules
disabled_rules:
  - discarded_notification_center_observer
  - notification_center_detachment
  - orphaned_doc_comment
  - todo
  - unused_capture_list
  - trailing_closure
  - force_try
  - force_unwrapping
  - vertical_whitespace
  - collection_alignment
  - multiline_function_chains
  - closure_body_length
  - extension_access_modifier
  - multiline_arguments_brackets
  - generic_type_name

# Analyzer Rules
analyzer_rules:
  - unused_closure_parameter
  - unused_control_flow_label
  - unused_declaration
  - unused_enumerated
  - unused_import
  - unused_optional_binding
  - unused_setter_value

# Enforced Rules
opt_in_rules:
  - private_outlet
  - private_subject
  - private_action
  - array_init
  - block_based_kvo
  - closing_brace
  - closure_end_indentation
  - closure_parameter_position
  - closure_spacing
  - comma
  - comment_spacing
  - compiler_protocol_init
  - computed_accessors_order
  - contains_over_filter_count
  - contains_over_filter_is_empty
  - contains_over_first_not_nil
  - contains_over_range_nil_comparison
  - control_statement
  - convenience_type
  - deployment_target
  - discouraged_assert
  - discouraged_direct_init
  - discouraged_object_literal
  - duplicate_imports
  - dynamic_inline
  - empty_collection_literal
  - empty_count
  - empty_enum_arguments
  - empty_parameters
  - empty_parentheses_with_trailing_closure
  - empty_string
  - explicit_init
  - fatal_error_message
  - file_name_no_space
  - first_where
  - flatmap_over_map_reduce
  - for_where
  - function_parameter_count
  - identical_operands
  - identifier_name
  - implicit_getter
  - is_disjoint
  - joined_default_parameter
  - large_tuple
  - last_where
  - leading_whitespace
  - legacy_cggeometry_functions
  - legacy_constant
  - legacy_constructor
  - legacy_hashing
  - legacy_multiple
  - legacy_nsgeometry_functions
  - legacy_random
  - line_length
  - literal_expression_end_indentation
  - lower_acl_than_parent
  - mark
  - modifier_order
  - multiline_arguments
  - multiline_literal_brackets
  - multiline_parameters
  - multiline_parameters_brackets
  - multiple_closures_with_trailing_closure
  - no_fallthrough_only
  - no_space_in_method_call
  - nslocalizedstring_require_bundle
  - nsobject_prefer_isequal
  - number_separator
  - opening_brace
  - operator_usage_whitespace
  - operator_whitespace
  - optional_enum_case_matching
  - overridden_super_call
  - prefer_self_type_over_type_of_self
  - prefer_zero_over_explicit_init
  - private_over_fileprivate
  - prohibited_super_call
  - protocol_property_accessors_order
  - reduce_boolean
  - reduce_into
  - redundant_discardable_let
  - redundant_nil_coalescing
  - redundant_objc_attribute
  - redundant_optional_initialization
  - redundant_set_access_control
  - redundant_string_enum_value
  - redundant_type_annotation
  - redundant_void_return
  - required_enum_case
  - return_arrow_whitespace
  - shorthand_operator
  - sorted_first_last
  - statement_position
  - static_operator
  - superfluous_disable_command
  - switch_case_alignment
  - syntactic_sugar
  - toggle_bool
  - trailing_comma
  - trailing_newline
  - trailing_semicolon
  - type_body_length
  - unavailable_function
  - unneeded_break_in_switch
  - unneeded_parentheses_in_closure_argument
  - untyped_error_in_catch
  - valid_ibinspectable
  - vertical_parameter_alignment
  - vertical_parameter_alignment_on_call
  - void_return
  - weak_delegate
  - yoda_condition

# Custom Rules Thresholds
file_length:
  warning: 600
  error: 1000
  ignore_comment_only_lines: true

function_body_length:
  warning: 100
  error: 150

function_parameter_count:
  warning: 8
  error: 12

identifier_name:
  min_length:
    error: 2
  max_length:
    warning: 60
    error: 100
  excluded:
    - Id
    - ID
    - on
    - On
    - ON
    - x
    - y
    - z
    - i
    - j
    - UI

type_name:
  excluded:
    - id
    - Id
    - ID
    - on
    - On
    - ON
    - UI

line_length:
  warning: 150
  error: 250
  ignores_comments: true

number_separator:
  minimum_length: 5

type_body_length:
  warning: 300
  error: 450

large_tuple:
  warning: 3
  error: 4

private_outlet:
  severity: warning

private_subject:
  severity: warning

private_action:
  severity: warning

EOF

# Create The SwiftFormatFile
cat > "$SWIFT_FORMAT_CONFIG" << 'EOF'
--swiftversion 5
--tabwidth 2
--indent 2
--binarygrouping ignore
--octalgrouping ignore
--hexgrouping ignore
--hexliteralcase lowercase
--ifdef no-indent
--patternlet inline
--wrapparameters before-first
--wraparguments before-first
--wrapconditions preserve
--wrapcollections before-first
--disable wrapMultilineStatementBraces
--self init-only
--extensionacl on-declarations
--disable blankLinesAtStartOfScope
--disable trailingCommas
--decimalgrouping ignore
EOF
echo "✅  SwiftLint & SwiftFormat Files Generated Succesfully  🫠"
