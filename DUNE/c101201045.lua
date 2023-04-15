--セレマテック・クラティス
function c101201045.initial_effect(c)
	c:EnableCounterPermit(0x1)
	c:SetCounterLimit(0x1,9)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--Place Spell Counter on this card
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c101201045.acop)
	c:RegisterEffect(e1)
	--Search 1 Spell or 1 Spellcaster monster, OR Special Summon 1 Spellcaster monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101201045,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101201045)
	e2:SetCost(c101201045.ctcost)
	e2:SetTarget(c101201045.cttg)
	e2:SetOperation(c101201045.ctop)
	c:RegisterEffect(e2)
	--Destruction replacement
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c101201045.reptg)
	c:RegisterEffect(e3)
end
function c101201045.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==1-tp and not re:IsActiveType(TYPE_SPELL) and c:GetFlagEffect(1)>0 then
		c:AddCounter(0x1,1)
	end
end
function c101201045.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x1,3,REASON_COST) end
	c:RemoveCounter(tp,0x1,3,REASON_COST)
end
function c101201045.thfilter(c)
	return (c:IsType(TYPE_SPELL) or (c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_EFFECT))) and c:IsAbleToHand()
end
function c101201045.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101201045.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101201045.thfilter,tp,LOCATION_DECK,0,1,nil)
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101201045.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)) end
end
function c101201045.ctop(e,tp,eg,ep,ev,re,r,rp)
	local thg=Duel.GetMatchingGroup(c101201045.thfilter,tp,LOCATION_DECK,0,nil)
	local spg=Duel.GetMatchingGroup(c101201045.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local b1=#thg>0
	local b2=#spg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(101201045,1),aux.Stringid(101201045,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(101201045,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(101201045,2))+1
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=thg:Select(tp,1,1,nil)
		if #g==0 then return end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=spg:Select(tp,1,1,nil)
		if #g==0 then return end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101201045.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
