function DuckTransaction()
    local self = DuckClass(Config.MagicString.KeyStringTransaction)

    self = __LoadId(self)
    self = __LoadLabel(self)
    self = __LoadOwner(self)
    self = __LoadTarget(self)
    self =  __LoadBalance(self)
    self =  __LoadRefunded(self)
    self =  __LoadPayedAt(self)
    self =  __LoadRefundedAt(self)

    self.loadFromDatabase = function(data)
        if data then
            self.setId(data.id)
            self.setLabel(data.label)
            self.setOwnerType(data.owner_type)
            self.setOwnerId(data.owner_id)
            self.setTargetType(data.target_type)
            self.setTargetId(data.target_id)
            self.setBalance(data.balance)
            self.setRefunded(data.refunded)
            self.setPayedAt(data.payed_at)
            self.setRefundedAt(data.refunded_at)
        else
            print("Error: No data provided to load DuckTransaction")
        end
    end

    self.toString = function()
        return string.format("DuckTransaction: { id: %d, label: '%s', owner_type: '%s', owner_id: %d, target_type: '%s', target_id: %d, balance: %.2f, refunded: %s }",
            self.getId(), self.getLabel(), self.getOwnerType(), self.getOwnerId(),
            self.getTargetType(), self.getTargetId(), self.getBalance(), tostring(self.getRefunded()))
    end

    self.storeInFile = function(f)
        f:write("        {\n")
        f:write("            id = " .. self.getId() .. ",\n")
        f:write("            label = " .. self.getLabel() .. ",\n")
        f:write("            owner_type = " .. self.getOwnerType() .. ",\n")
        f:write("            owner_id = " .. self.getOwnerId() .. ",\n")
        f:write("            target_type = " .. self.getTargetType() .. ",\n")
        f:write("            target_id = " .. self.getTargetId() .. ",\n")
        f:write("            balance = " .. self.getBalance() .. ",\n")
        f:write("            refunded = " .. tostring(self.getRefunded()) .. ",\n")
        f:write("            payed_at = " .. (self.getPayedAt() or "nil") .. ",\n")
        f:write("            refunded_at = " .. (self.getRefundedAt() or "nil") .. "\n")
        f:write("        },\n")
    end


    self.pay = function()
        if not self.getPayedAt() then
            if self.getOwnerType() == Config.MagicString.KeyStringAccount then
                if self.getTargetType() == Config.MagicString.KeyStringAccount then
                    self.getOwner().addMoney(self.getBalance())
                    self.getTarget().removeMoney(self.getBalance())
                    self.setPayedAt(os.time())
                    return true, 'Payment successful'
                end
                return false, 'Payment failed: Target is not an account'
            end
            return false, 'Payment failed: Owner is not an account'
        end
        return false, 'Payment already made'
    end

    self.refund = function()
        if not self.getPayedAt() then
            print("Error: Cannot refund before payment")
            return false, 'Cannot refund before payment'
        end
        if not self.getRefunded() then
            if self.getOwnerType() == Config.MagicString.KeyStringAccount then
                if self.getTargetType() == Config.MagicString.KeyStringAccount then
                    self.getTarget().addMoney(self.getBalance())
                    self.getOwner().removeMoney(self.getBalance())
                    self.setRefundedAt(os.time())
                    self.setRefunded(true)
                    return true, 'Refund successful'
                end
                return false, 'Refund failed: Target is not an account'
            end
            return false, 'Refund failed: Owner is not an account'
        end
        return false, 'Refund already made'
    end


    return self
end