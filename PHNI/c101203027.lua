--バーサーク・デーモン
--lua by zengsxing
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end
function s.cfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function s.fselect(g)
	return g:IsExists(Card.IsRace,1,nil,RACE_FIEND)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local rg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and rg:CheckSubGroup(s.fselect,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=rg:SelectSubGroup(tp,s.fselect,false,2,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetsRelateToChain()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		if #tg>0 and Duel.Destroy(tg,REASON_EFFECT)>0 then
			local og=Duel.GetOperatedGroup()
			Duel.RaiseSingleEvent(c,EVENT_CUSTOM+id,e,REASON_EFFECT,tp,tp,#og)
		end
	end
end
function s.cfilter1(c)
	return c:IsFaceup() and c:GetBaseAttack()>0
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return ev==1 and chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.cfilter1(chkc) end
	local c=e:GetHandler()
	if chk==0 then return c:IsRelateToEffect(e)
		and Duel.IsExistingTarget(s.cfilter1,tp,0,LOCATION_MZONE,ev,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.cfilter1,tp,0,LOCATION_MZONE,ev,ev,nil)
	local atk=g:GetSum(Card.GetBaseAttack)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,c,1,tp,atk)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetsRelateToChain()
	local atk=tg:GetSum(Card.GetBaseAttack)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
	end
end