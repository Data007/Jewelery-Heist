module Mongoid
  class Criteria
    def find(*args)
      ids = args.__find_args__
      if (ids.all? {|query_id| query_id.is_a?(Integer)})
        ids.each do |query_id|
          sequence_fields.each do |sequence_field|
            @document ||= where(sequence_field.to_sym => query_id).first
          end
        end
      else
        @document ||= super(args)
      end
      @document
    end
  end
end
