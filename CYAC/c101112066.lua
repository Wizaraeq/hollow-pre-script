--おすすめ軍貫握り
function c101112066.initial_effect(c)
	c:EnableCounterPermit(0x163)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Effects
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112066,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c101112066.cost)
	e2:SetTarget(c101112066.target)
	e2:SetOperation(c101112066.operation)
	c:RegisterEffect(e2)
	--Register a flag before it is destroyed
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c101112066.val)
	c:RegisterEffect(e3)
	--Make the opponent pay LP
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101112066,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c101112066.lpcond)
	e4:SetOperation(c101112066.lpop)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c101112066.costfilter(c)
	return c:IsCode(24639891) and not c:IsPublic()
end
function c101112066.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101112066.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101112066.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c101112066.shipfilter(c)
	return c:IsSetCard(0x166) and c:IsType(TYPE_XYZ) and not c:IsPublic()
end
function c101112066.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101112066.shipfilter,tp,LOCATION_EXTRA,0,1,nil) end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,c,1,tp,0x163)
end
function c101112066.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c101112066.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:AddCounter(0x163,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101112066.shipfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if #g==0 then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleExtra(tp)
	local codes={61027400,42377643,78362751}
	local afilter={codes[1],OPCODE_ISCODE}
	if #codes>1 then
		--or ... or c:IsCode(codes[i])
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	local res=Duel.AnnounceCard(1-tp,table.unpack(afilter))
	Duel.Hint(HINT_CARD,tp,res)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sc=Duel.SelectMatchingCard(tp,c101112066.thfilter,tp,LOCATION_DECK,0,1,1,nil,res)
	if #sc>0 then
		Duel.SendtoHand(sc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sc)
	elseif c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c101112066.val(e)
	e:SetLabel(e:GetHandler():GetCounter(0x163))
end
function c101112066.lpcond(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousControler(tp) and c:IsReason(REASON_DESTROY) and c:GetReasonPlayer()==1-tp 
end
function c101112066.lpop(e,tp,eg,ep,ev,re,r,rp)
	local value=e:GetLabelObject():GetLabel()*500
	if value>0 and Duel.GetLP(1-tp)>=value then
		Duel.PayLPCost(1-tp,value)
	end
end
