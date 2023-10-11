--Asset Mountis
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--Change the position of monsters and the attributes of insect monsters
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.poscon)
	e2:SetTarget(s.postg)
	e2:SetOperation(s.posop)
	c:RegisterEffect(e2)
	--Search 1 Level 8 or higher Insect monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,id+o*2)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.filter(c)
	return c:IsFaceup() and c:IsLevelBelow(6)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil)
end
function s.insectfilter(c,att,lv)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and (not c:IsAttribute(att) or not c:IsLevel(lv))
end
function s.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local posg=Duel.GetMatchingGroup(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return c:IsLevelAbove(1) and #posg>0
		and Duel.IsExistingMatchingCard(s.insectfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttribute(),c:GetLevel()) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,posg,#posg,tp,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local posg=Duel.GetMatchingGroup(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.ChangePosition(posg,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local att=c:GetAttribute()
	local lv=c:IsLevelAbove(1) and c:GetLevel() or 0
	local insg=Duel.GetMatchingGroup(s.insectfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,att,lv)
	if #insg==0 then return end
	for tc in aux.Next(insg) do
		if not tc:IsAttribute(att) then
			--Attribute becomes the same as this card's
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetValue(att)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		if not tc:IsLevel(lv) then
			--Level becomes the same as this card's
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_LEVEL)
			e2:SetValue(lv)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsRace(RACE_INSECT)
end
function s.thfilter(c)
	return c:IsLevelAbove(8) and c:IsRace(RACE_INSECT) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end