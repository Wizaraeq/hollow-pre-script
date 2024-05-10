--機雷化するクリボー
local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Equip this card to an opponent's monster that activated its effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_EQUIP+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.eqcon)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa4) and c:GetOriginalType()&TYPE_MONSTER>0
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local trig_loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return rp==1-tp and re:GetActivateLocation()==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and rc:IsRelateToEffect(re) and rc:IsFaceup()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetTargetCard(re:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,tp,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsControler(tp)) then return end
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
		Duel.SendtoGrave(c,REASON_RULE,PLAYER_NONE,PLAYER_NONE)
	elseif Duel.Equip(tp,c,tc) then
		--Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(s.eqlimit)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		--The equipped monster's effects are negated
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end