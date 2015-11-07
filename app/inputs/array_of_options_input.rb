class ArrayOfOptionsInput < SimpleForm::Inputs::CollectionInput#StringInput#SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    input_html_options[:type] ||= input_type

    options_collection = collection || object.public_send(attribute_name)

    fields = if options_collection.any?
      fields_number = 0
      options_collection.map do |item|
        fields_number += 1

        @builder.text_field(nil,
          input_html_options.merge(
            value: item.values.first,
            label: "Option: #{fields_number}",
            name: "#{object_name}[#{attribute_name}][]",
            class: 'form-control'
          )
        )
      end
    else
      [@builder.text_field(nil,
        input_html_options.merge(
          value: '',
          label: 'Option 1: ',
          name: "#{object_name}[#{attribute_name}][]",
          class: 'form-control')
      ), nil]
    end

    fields.join('<br>').html_safe
  end

  def input_type
    :string
  end
end
