--Giant Beetrooper Invincible Atlas
function c101105089.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_INSECT),2)
	c:EnableReviveLimit()
	--cannot target this card
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetCondition(c101105089.indcon)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--It cannot be destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101105089.indcon)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--sp limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c101105089.sumlimit)
	c:RegisterEffect(e3)
	--Special Summon OR Gain ATK.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,101105089)
	e4:SetCost(c101105089.spatkcost)
	e4:SetTarget(c101105089.spatktg)
	e4:SetOperation(c101105089.spatkop)
	c:RegisterEffect(e4)
end
function c101105089.sumlimit(e,c)
	return not c:IsRace(RACE_INSECT)
end
function c101105089.indcon(e)
	local c=e:GetHandler()
	return c:IsAttackBelow(3000) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c101105089.cfilter(c,tp,tc,ft,spcheck)
	return c:IsRace(RACE_INSECT) and (c~=tc or (spcheck and Duel.GetMZoneCount(tp,c)>0))
end
function c101105089.spatkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local spcheck=Duel.IsExistingMatchingCard(c101105089.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101105089.cfilter,1,nil,tp,c,ft,spcheck) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c101105089.cfilter,1,1,nil,tp,c,ft,spcheck)
	Duel.Release(g,REASON_COST)
end
function c101105089.spfilter(c,e,tp)
	return c:IsSetCard(0x270) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101105089.spatktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local atk=c:IsLocation(LOCATION_MZONE) 
	local spcheck=Duel.IsExistingMatchingCard(c101105089.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local sel=-1
	if atk and spcheck then
		sel=Duel.SelectOption(tp,aux.Stringid(101105089,0),aux.Stringid(101105089,1))
	elseif spcheck then
		sel=Duel.SelectOption(tp,aux.Stringid(101105089,0))
	elseif atk then
		sel=Duel.SelectOption(tp,aux.Stringid(101105089,1))+1
	end
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_ATKCHANGE)
	end
end
function c101105089.spatkop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101105089.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g==0 then return end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(2000)
		c:RegisterEffect(e1)
	end
end