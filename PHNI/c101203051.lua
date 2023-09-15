--マジェスペクター・オルト
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_PENDULUM),2,99,s.lcheck)
	c:EnableReviveLimit()
	--Add 2 "Majespecter" Pendulum Monsters to the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xd0)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function s.tefilter(c)
	return c:IsSetCard(0xd0) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_EXTRA,0,1,2,nil)
	if #g==0 or Duel.SendtoHand(g,tp,REASON_EFFECT)==0 or g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)==0 then return end
	Duel.ConfirmCards(1-tp,g)
	local dg=Duel.GetMatchingGroup(s.tefilter,tp,LOCATION_DECK,0,nil)
	if #dg==0 or not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local teg=dg:SelectSubGroup(tp,aux.dncheck,false,1,2)
	if #teg>0 then
		Duel.BreakEffect()
		Duel.SendtoExtraP(teg,tp,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.limit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.limit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsSetCard(0xd0) or c:IsSetCard(0xc7))
end