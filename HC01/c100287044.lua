--ファイアウォール・ドラゴン・ダークフルード－ネオテンペスト
function c100287044.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE),3)
	c:EnableReviveLimit()
	--Negate opponent's monster effects activated in the Battle Phase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c100287044.negcon)
	e1:SetOperation(c100287044.negop)
	c:RegisterEffect(e1)
	--Gain Attribute and ATK
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100287044,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCountLimit(1,100287044)
	e2:SetCondition(c100287044.gycon)
	e2:SetTarget(c100287044.gytg)
	e2:SetOperation(c100287044.gyop)
	c:RegisterEffect(e2)
	--Multiple attacks
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e3:SetValue(c100287044.raval)
	c:RegisterEffect(e3)
end
function c100287044.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and rp==1-tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c100287044.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,100287044)
	Duel.NegateEffect(ev)
end
function c100287044.gycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c100287044.gyfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsAbleToGrave()
end
function c100287044.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100287044.gyfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c100287044.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,c100287044.gyfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE)
		and c:IsRelateToEffect(e) and c:IsFaceup() then
		--Gain Attribute
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_ADD_ATTRIBUTE)
		e1:SetValue(tc:GetAttribute())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		--Increase ATK
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(2500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)
	end 
end
function c100287044.raval(e,c)
	local att=e:GetHandler():GetAttribute()
	local ct=0
	while att~=0 do
		if (att&0x1)~=0 then ct=ct+1 end
		att=(att>>1)
	end
	return ct-1
end
