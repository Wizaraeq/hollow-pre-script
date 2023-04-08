--ＢＫ プロモーター
function c100428034.initial_effect(c)
	--Special Summon this card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100428034,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100428034)
	e1:SetCondition(c100428034.selfspcon)
	e1:SetCost(c100428034.sumlimitcost)
	e1:SetTarget(c100428034.selfsptg)
	e1:SetOperation(c100428034.selfspop)
	c:RegisterEffect(e1)
	--Special Summon up to 2 "Battlin' Boxer" monsters from the Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100428034,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100428034+100)
	e2:SetCost(c100428034.spcost)
	e2:SetTarget(c100428034.sptg)
	e2:SetOperation(c100428034.spop)
	c:RegisterEffect(e2)
	--Increase or decrease the Level of all "Battlin' Boxer" monsters you control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100428034,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,100428034+200)
	e3:SetCost(c100428034.lvcost)
	e3:SetTarget(c100428034.lvtg)
	e3:SetOperation(c100428034.lvop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(100428034,ACTIVITY_SPSUMMON,c100428034.activityfilter)
end
function c100428034.activityfilter(c)
	return c:IsSetCard(0x1084)
end
function c100428034.sumlimitcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(100428034,tp,ACTIVITY_SPSUMMON)==0 end
	--Cannot Special Summon, except "Battlin' Boxer" monsters
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100428034.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function c100428034.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x1084)
end
function c100428034.selfspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c100428034.selfsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c100428034.selfspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100428034.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable()
		and c100428034.sumlimitcost(e,tp,eg,ep,ev,re,r,rp,0) end
	Duel.Release(e:GetHandler(),REASON_COST)
	c100428034.sumlimitcost(e,tp,eg,ep,ev,re,r,rp,1)
end
function c100428034.spfilter(c,e,tp)
	return c:IsSetCard(0x1084) and not c:IsCode(100428034) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c100428034.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c100428034.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and g:CheckSubGroup(aux.dncheck,2,2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c100428034.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetMatchingGroup(c100428034.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if sg then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100428034.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and c100428034.sumlimitcost(e,tp,eg,ep,ev,re,r,rp,0) end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	c100428034.sumlimitcost(e,tp,eg,ep,ev,re,r,rp,1)
end
function c100428034.lvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1084) and c:IsLevelAbove(1)
end
function c100428034.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100428034.lvfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 end
end
function c100428034.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100428034.lvfilter,tp,LOCATION_MZONE,0,nil)
	if #g==0 then return end
	local decrease=g:FilterCount(Card.IsLevel,nil,1)<#g
	if not decrease then
		op=Duel.SelectOption(tp,aux.Stringid(100428034,4))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100428034,4),aux.Stringid(100428034,5))
	end
	if op==0 then value=1 else value=-1 end
	local c=e:GetHandler()
	for tc in aux.Next(g) do
		---Increase or decrease the level of "Battlin' Boxer" monsters
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(value)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
