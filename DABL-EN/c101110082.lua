--Zalamander Catalyzer
function c101110082.initial_effect(c)
	-- Special Summon and discard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110082,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101110082)
	e1:SetTarget(c101110082.sptg)
	e1:SetOperation(c101110082.spop)
	c:RegisterEffect(e1)
	-- Add this card to the hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(aux.Stringid(101110082,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101110082+100)
	e2:SetCondition(c101110082.thcon)
	e2:SetTarget(c101110082.thtg)
	e2:SetOperation(c101110082.thop)
	c:RegisterEffect(e2)
end
function c101110082.spcostfilter(c,e,tp,dc_chk,sp_chk)
	return c:IsRace(RACE_FIEND) and not c:IsPublic()
		and ((sp_chk and c:IsDiscardable(REASON_EFFECT)) or (dc_chk and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c101110082.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local dc_chk=c:IsDiscardable(REASON_EFFECT)
	local sp_chk=c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if chk==0 then return (dc_chk or sp_chk) and not c:IsPublic()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101110082.spcostfilter,tp,LOCATION_HAND,0,1,c,e,tp,dc_chk,sp_chk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101110082.spcostfilter,tp,LOCATION_HAND,0,1,1,c,e,tp,dc_chk,sp_chk)
	g:AddCard(c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,g,1,0,0)
end
function c101110082.spfilter(c,e,tp,g)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:IsExists(Card.IsDiscardable,1,c,REASON_EFFECT)
end
function c101110082.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:FilterSelect(tp,c101110082.spfilter,1,1,nil,e,tp,g)
	if #sg==1 then
		g:Sub(sg)
		Duel.SpecialSummon(sg,1,tp,tp,false,false,POS_FACEUP)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	end
end
function c101110082.thconfilter(c,tp,ct)
	local bc=c:GetBattleTarget()
	return (c:IsPreviousControler(tp) and c:GetPreviousRaceOnField()&RACE_FIEND>0)
		or (ct==1 and bc and bc:IsControler(tp) and bc:IsRace(RACE_FIEND))
end
function c101110082.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c101110082.thconfilter,1,nil,tp,#eg)
end
function c101110082.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_GRAVE)
end
function c101110082.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end