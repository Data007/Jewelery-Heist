class Hash
  def method_missing(sym,*args,&blk)
    return self[sym] if self.key?(sym)
    return self[sym.to_s] if self.key?(sym.to_s)
    super
  end
end