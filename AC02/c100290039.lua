--アマゾネスの秘湯
function c100290039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c100290039.activate)
	c:RegisterEffect(e1)
	--Gain LP equal to the battle damage taken
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100290039,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,100290039)
	e2:SetCondition(c100290039.lpcond)
	e2:SetTarget(c100290039.lptg)
	e2:SetOperation(c100290039.lpop)
	c:RegisterEffect(e2)
end
function c100290039.thfilter(c)
	return c:IsSetCard(0x4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100290039.pendfilter(c)
	return c:IsSetCard(0x4) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c100290039.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c100290039.thfilter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c100290039.pendfilter,tp,LOCATION_DECK,0,nil)
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
function c100290039.amzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4) and c:GetOriginalType()&TYPE_MONSTER>0
end
function c100290039.lpcond(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.IsExistingMatchingCard(c100290039.amzfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100290039.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c100290039.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
end 