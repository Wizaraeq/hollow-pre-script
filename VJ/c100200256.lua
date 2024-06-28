--ＯＴｏＮａＲｉサンダー
local s,id,o=GetID()
function s.initial_effect(c)
	--Special Summon this card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Attach 2 Level 4 LIGHT Thunder monsters to an Xyz monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.atttg)
	e2:SetOperation(s.attop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_THUNDER)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,2,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
function s.attfilter(c)
	return c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_THUNDER)
		and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function s.xcfilter(c,tp,ec,mg)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCanOverlay()
		and mg:IsExists(Card.IsCanOverlay,1,nil,c,tp,REASON_EFFECT)
end
function s.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if not s.attfilter(c) then return false end
	local mg=Duel.GetMatchingGroup(s.attfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,c)
	if #mg==0 then return false end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.xcfilter(chkc,tp,c,mg) end
	if chk==0 then return Duel.IsExistingTarget(s.xcfilter,tp,LOCATION_MZONE,0,1,nil,tp,c,mg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.xcfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,c,mg)
end
function s.attop(e,tp,eg,ep,ev,re,r,rp)
	local xc=Duel.GetFirstTarget()
	if not (xc:IsRelateToEffect(e) and xc:IsType(TYPE_XYZ)) then return end
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and s.attfilter(c) and c:IsCanOverlay()) then return end
	local mg=Duel.GetMatchingGroup(s.attfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,c)
	if #mg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACH)
	local g=mg:FilterSelect(tp,Card.IsCanOverlay,1,1,nil,xc,tp,REASON_EFFECT)
	if #g>0 then
		Duel.Overlay(xc,g+c)
	end
end