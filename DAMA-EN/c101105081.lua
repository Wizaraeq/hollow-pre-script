--Baby Mudragon
function c101105081.initial_effect(c)
	--nontuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e1)
	-- Change Type or Attribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101105081,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c101105081.chcon)
	e2:SetTarget(c101105081.chtg)
	e2:SetOperation(c101105081.chop)
	c:RegisterEffect(e2)
end
function c101105081.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c101105081.chfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsCanBeEffectTarget(e)
end
function c101105081.ahfilter(c,att)
	return not c:IsAttribute(att)
end
function c101105081.rhfilter(c,rc)
	return not c:IsRace(att)
end
function c101105081.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c101105081.chfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:FilterSelect(tp,c101105081.ahfilter,1,1,nil)
	Duel.SetTargetCard(sg)
	if Duel.SelectOption(tp,aux.Stringid(101105081,1),aux.Stringid(101105081,2))==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
		local rc=Duel.AnnounceRace(tp,1,RACE_ALL-sg:GetFirst():GetRace())
		e:SetLabel(0,rc)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		local att=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL-sg:GetFirst():GetAttribute())
		e:SetLabel(1,att)
	end
end
function c101105081.chop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local op,decl=e:GetLabel()
	if op==0 and not tc:IsRace(decl) then
		-- Change monster type
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(decl)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	elseif op==1 and not tc:IsAttribute(decl) then
		-- Change attribute
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(decl)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end