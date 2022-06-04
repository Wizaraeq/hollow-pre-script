--アマゾネス拝謁の間
function c100290038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c100290038.activate)
	c:RegisterEffect(e1)
	--Gain LP equal to a target's ATK
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100290038,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,100290038)
	e2:SetCondition(c100290038.lpcond)
	e2:SetTarget(c100290038.lptg)
	e2:SetOperation(c100290038.lpop)
	c:RegisterEffect(e2)
end
function c100290038.thfilter(c)
	return c:IsSetCard(0x4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c100290038.pendfilter(c)
	return c:IsSetCard(0x4) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c100290038.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100290038.thfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100290038.pendfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	local b1=g1:GetCount()>0
	local b2=g2:GetCount()>0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	if not (b1 or b2) then return end
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(100290039,1)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(100290039,2)
		opval[off]=1
		off=off+1
	end
	if b1 or b2 then
	ops[off]=aux.Stringid(100290039,3)
	opval[off]=2
	off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	elseif sel==1 then
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg2=g2:Select(tp,1,1,nil)
		local tc=sg2:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c100290038.amzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4) and c:GetOriginalType()&TYPE_MONSTER>0
end
function c100290038.lpcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100290038.amzfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100290038.lpfilter(c,e,p)
	return c:IsControler(p) and c:IsFaceup() and c:GetAttack()>0 and c:IsCanBeEffectTarget(e)
end
function c100290038.lptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c100290038.lpfilter(chkc,e,1-tp) end
	if chk==0 then return eg:IsExists(c100290038.lpfilter,1,nil,e,1-tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,c100290038.lpfilter,1,1,nil,e,1-tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function c100290038.lpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local value=tc:GetAttack()
		if value==0 then return end
		Duel.Recover(tp,value,REASON_EFFECT)
	end
end