module Mongoid
  class Criteria
    def find(*args)
      ids = args.__find_args__
      ids.each do |query_id|
        if query_id.is_a?(Integer)
          sequence_fields.each do |sequence_field|
            query = where(sequence_field.to_sym => query_id).to_a
            @documents ? @documents << query : @documents = query
          end
        else
          query = for_ids(ids).execute_or_raise(ids, args.multi_arged?).to_a
          @documents ? @documents << query : @documents = query
        end
      end
      @documents.flatten!.compact!
      return @documents.length > 1 ? @documents : @documents.first
    end
  end
end
