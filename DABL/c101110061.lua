--異譚の忍法帖
function c101110061.initial_effect(c)
	--Set 1 "Ninjitsu Art" Spell/Trap and/or 1 "Ninja" monster 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110061,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101110061)
	e1:SetCondition(c101110061.condition)
	e1:SetTarget(c101110061.target)
	e1:SetOperation(c101110061.operation)
	c:RegisterEffect(e1)
	--Change 1 face-up monster to face-down Defense Position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110061,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,101110061+100)
	e2:SetCondition(c101110061.poscond)
	e2:SetTarget(c101110061.postg)
	e2:SetOperation(c101110061.posop)
	c:RegisterEffect(e2)
end
function c101110061.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0
end
function c101110061.ninjitsu(c,zone_chk)
	return c:IsSetCard(0x61) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsCode(101110061) and (zone_chk or c:IsType(TYPE_FIELD))
end
function c101110061.ninja(c,e,tp)
	return c:IsSetCard(0x2b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and not c:IsCode(101110061)
end
function c101110061.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mzones=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local stzones=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g1=Duel.GetMatchingGroup(c101110061.ninja,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c101110061.ninjitsu,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,stzones>0)
	g1:Merge(g2)
	if chk==0 then return g1:CheckSubGroup(c101110061.rescon,2,2,e,tp) end
end
function c101110061.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetLocation)==#sg and (sg:FilterCount(c101110061.ninjitsu,nil,true)==1 or sg:FilterCount(c101110061.ninja,nil,e,tp)==1)
end
function c101110061.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c101110061.ninja),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c101110061.ninjitsu),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,true)
	g1:Merge(g2)
	if #g1==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g1:SelectSubGroup(tp,c101110061.rescon,false,2,2,e,tp)
	local tc=sg:GetFirst()
	while tc do
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
			Duel.SSet(tp,tc,tp,false)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		end
		tc=sg:GetNext()
	end
	Duel.ConfirmCards(1-tp,sg)
end
function c101110061.poscond(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c101110061.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c101110061.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101110061.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101110061.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101110061.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,POS_FACEDOWN_DEFENSE)
end
function c101110061.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end