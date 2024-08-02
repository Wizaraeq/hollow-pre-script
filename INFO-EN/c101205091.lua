--Mimighoul Dragon
local s,id,o=GetID()
function s.initial_effect(c)
	--FLIP: Apply effects in sequence
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_F)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.effcon)
	e1:SetTarget(s.effstg)
	e1:SetOperation(s.effsop)
	c:RegisterEffect(e1)
	--Special Summon this card to the opponent's field in face-down Defense Position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.selfsptg)
	e2:SetOperation(s.selfspop)
	c:RegisterEffect(e2)
	--Search 1 "Mimighoul" Spell/Trap
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,id+o*2)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function s.desfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0x1b7)
end
function s.effstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,0,nil)
	if #dg>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
	end
	local c=e:GetHandler()
	if c:IsAbleToChangeControler() and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 then
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,c,1,0,0)
	end
end
function s.effsop(e,tp,eg,ep,ev,re,r,rp,chk)
	local break_chk=false
	local dg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,0,nil)
	if #dg>0 then
		break_chk=Duel.Destroy(dg,REASON_EFFECT)>0
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if break_chk then Duel.BreakEffect() end
		Duel.GetControl(c,1-tp)
	end
end
function s.selfsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.selfspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end
function s.thfilter(c)
	return c:IsSetCard(0x1b7) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
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